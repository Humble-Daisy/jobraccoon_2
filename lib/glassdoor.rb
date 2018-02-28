require 'httparty'
require 'httmultiparty'
require 'json'

class GlassdoorApi 
  include HTTParty
  include HTTMultiParty

  @addr = ""
  attr_reader :token
  @email = ""
  @password = ""
  @api_key = ""
  @max_age = 0

  def initialize(addr)
    @token = ""
    @addr = addr
  end

  def check_err(resp)
    if resp.code == 200
      return resp
    end

    err = nil
    begin
      # Try creating error from response body.
      params = JSON.parse(resp.body)
      err = RmApiError.new(
        resp.code, params["SubCode"], params["Message"], params["Context"])
    rescue
      # Failed to parse the response body. Just return the error code.
      err = RmApiError.new(resp.code, -1, "#{resp}", "")
    end
    raise err
  end

  def renew_session()
    if @api_key.length != 0
      session_create_api_key(@api_key, @max_age)
    else
      session_create_basic(@email, @password, @max_age)
    end
  end

  def get_retry(path)
    path = "#@addr/#{path}"
    begin
      auth = {username: @token, password:""}
      return check_err(HTTParty.get(path, basic_auth:auth))
    rescue RmApiError => err
      if err.code == 401 and err.sub_code == 1
        renew_session()
        retry
      else
        raise err
      end
    end
  end

  def get_file_retry(path, outpath)
    path = "#@addr/#{path}"
    begin
      auth = {username: @token, password:""}
      File.open(outpath, "wb") do |f|
        f.binmode
        resp = check_err(HTTParty.get(path, basic_auth:auth))
        f.write resp.parsed_response
        return
      end
    rescue RmApiError => err
      if err.code == 401 and err.sub_code == 1
        renew_session()
        retry
      else
        raise err
      end
    end
  end

  def post_retry(path, body)
    path = "#@addr/#{path}"
    begin
      auth = {username: @token, password:""}
      return check_err(HTTParty.post(path, body:body, basic_auth:auth))
    rescue RmApiError => err
      if err.code == 401 and err.sub_code == 1
        renew_session()
        retry
      else
        raise err
      end
    end
  end

  def post_file_retry(path, filepath)
    path = "#@addr/#{path}"
    begin
      auth = {username: @token, password:""}
      return check_err(HTTMultiParty.post(
                        path,
                        query: { Upload: File.new(filepath) },
                        basic_auth: auth))
    rescue RmApiError => err
      if err.code == 401 and err.sub_code == 1
        renew_session()
        retry
      else
        raise err
      end
    end
  end

  def user_create_basic(email, password)
    resp = check_err(
      HTTParty.post(
      "#@addr/pub/user/create/basic",
      body: {
        Email:email,
        Password:password
      }))
    return JSON.parse(resp.body)["Id"]
  end

  def session_create_basic(email, password, max_age)
    @token = ""
    @email = email
    @password = password
    @api_key = ""
    @max_age = max_age

    resp = check_err(
      HTTParty.post(
      "#@addr/pub/session/create/basic",
      body: {
        Email: email,
        Password: password,
        MaxAge: max_age
      }))

    @token = JSON.parse(resp.body)["Token"]
  end

  def session_create_api_key(api_key, max_age)
    @token = ""
    @email = ""
    @password = ""
    @api_key = api_key
    @max_age = max_age

    resp = check_err(
      HTTParty.post(
      "#@addr/pub/session/create/api_key",
      body: {
        ApiKey: api_key,
        MaxAge: max_age
      }))

    @token = JSON.parse(resp.body)["Token"]
  end

  def session_restore(key, max_age, token)
    @api_key = key
    @max_age = max_age
    @token = token
  end

  def session_renew(max_age)
    resp = post_retry("auth/session/create", { MaxAge: max_age })
    @token = JSON.parse(resp.body)["Token"]
  end

  def user_get()
    resp = get_retry("auth/user/get")
    return RmApiUser.new(self, JSON.parse(resp.body))
  end

  def magazine_create(title, description, free)
    resp = post_retry(
      "auth/dist_magazine/create",
      {
        Title: title,
        Description: description,
        Free: free
      })
    return JSON.parse(resp.body)["Id"]
  end

  def magazine_get(id)
    resp = get_retry("auth/dist_magazine/get/#{id}")
    return DistMagazine.new(self, JSON.parse(resp.body))
  end

  def magazine_list(order_by, ascending, deleted)
    resp = post_retry(
      "auth/dist_magazine/list",
      {
        OrderBy: order_by,
        Ascending: ascending,
        Deleted: deleted
      })
    data = JSON.parse(resp.body)

    magazines = []
    data["Rows"].each { |o|
      magazines << DistMagazine.new(self, o)
    }

    return magazines
  end

  def edition_create(mag_id, title, description, published_at, free)
    resp = post_retry(
      "auth/dist_edition/#{mag_id}/create",
      {
        Title: title,
        Description: description,
        PublishedAt: published_at,
        Free: free
      })
    return JSON.parse(resp.body)["Id"]
  end

  def edition_get(mag_id, id)
    resp = get_retry("auth/dist_edition/#{mag_id}/get/#{id}")
    return DistEdition.new(self, JSON.parse(resp.body))
  end

end

class RmApiUser
  @cl = nil
  attr_reader :id
  attr_reader :email
  attr_reader :api_key

  def initialize(client, o)
    @cl = client
    from_json(o)
  end

  def from_json(o)
    @id = o["Id"]
    @email = o["Email"]
    @api_key = o["ApiKey"]
  end

  def update_email(email)
    @email = email
    return @cl.post_retry("auth/user/update/email", { Email: email })
  end

  def update_password(current, new)
    return @cl.post_retry("auth/user/update/password",
                          { CurPassword: cur, NewPassword: new})
  end

  def update_api_key()
    return @cl.post_retry("auth/user/update/api_key", {})
  end
end


class DistMagazine

  attr_accessor :id
  attr_accessor :user_id
  attr_accessor :app_prod_id
  attr_accessor :ext_id
  attr_accessor :created_at
  attr_accessor :updated_at
  attr_accessor :deleted
  attr_accessor :title
  attr_accessor :description
  attr_accessor :sub_model
  attr_accessor :webhook_auth
  attr_accessor :webhook_auth_form
  attr_accessor :webhook_auth_form_css
  attr_accessor :webhook_reader_info
  attr_accessor :app_store_password
  attr_accessor :play_store_secret
  attr_accessor :play_store_rsa_pub

  @cl = nil
  @orig = nil

  private

  def save_col?(name)
    return [
      'ext_id', 'app_prod_id', 'deleted', 'title', 'description', 'sub_model',
      'webhook_auth', 'webhook_auth_form', 'webhook_auth_form_css',
      'webhook_reader_info', 'app_store_password', 'play_store_secret',
      'play_store_rsa_pub'].include? name
  end

  public

  def initialize(client, o)
    @cl = client
    from_json(o)

    @orig = {}
    self.instance_variables.each do |name|
      name = name[1..-1]
      if !save_col? name
        next
      end

      @orig[name] = self.instance_variable_get('@' + name)
    end
  end

  def from_json(o)
    @id = o["Id"]
    @user_id = o["UserId"]
    @ext_id = o["ExtId"]
    @app_prod_id = o["AppProdId"]
    @created_at = o["CreatedAt"]
    @updated_at = o["UpdateAt"]
    @deleted = o["Deleted"]
    @title = o["Title"]
    @description = o["Description"]
    @sub_model = o["SubModel"]
    @webhook_auth = o["WebhookAuth"]
    @webhook_auth_form = o["WebhookAuthForm"]
    @webhook_auth_form_css = o["WebhookAuthFormCss"]
    @webhook_reader_info = o["WebhookReaderInfo"]
    @app_store_password = o["AppStorePassword"]
    @play_store_secret = o["PlayStoreSecret"]
    @play_store_rsa_pub = o["PlayStoreRsaPub"]
  end

  def update
    self.instance_variables.each do |name|
      name = name[1..-1]
      if !save_col? name
        next
      end

      value = instance_variable_get '@' + name
      if @orig[name] == value
        next
      end

      @cl.post_retry(
        "auth/dist_magazine/update/#@id/#{name}",
        { Value:value })
    end
  end

  def edition_create(title, description, published_at, free)
    resp = @cl.post_retry(
      "auth/dist_edition/#@id/create",
      {
        Title: title,
        Description: description,
        PublishedAt: published_at,
        Free: free
      })
    return JSON.parse(resp.body)["Id"]
  end

  def edition_get(id)
    return @cl.edition_get(@id, id)
  end

  def edition_list(order_by, ascending, deleted)
    resp = @cl.post_retry(
      "auth/dist_edition/#@id/list",
      {
        OrderBy: order_by,
        Ascending: ascending,
        Deleted: deleted
      })
    data = JSON.parse(resp.body)

    editions = []
    data["Rows"].each { |o|
      editions << DistEdition.new(@cl, o)
    }
    return editions
  end

end


class DistEdition
  attr_accessor :id
  attr_accessor :user_id
  attr_accessor :magazine_id
  attr_accessor :app_prod_id
  attr_accessor :ext_id
  attr_accessor :groups
  attr_accessor :categories
  attr_accessor :created_at
  attr_accessor :updated_at
  attr_accessor :published_at
  attr_accessor :deleted
  attr_accessor :title
  attr_accessor :description
  attr_accessor :free
  attr_accessor :source_ext
  attr_accessor :published
  attr_accessor :proc_started_at
  attr_accessor :proc_state
  attr_accessor :proc_version

  @cl = nil
  @orig = nil

  private

  def save_col?(name)
    return ['app_prod_id', 'ext_id', 'groups', 'published_at', 'deleted',
            'title', 'description', 'free', 'published', 'categories'].include? name

  end

  public

  def initialize(client, o)
    @cl = client
    from_json(o)

    @orig = {}
    self.instance_variables.each do |name|
      name = name[1..-1]
      if !save_col? name
        next
      end

      @orig[name] = self.instance_variable_get('@' + name)
    end
  end

  def from_json(o)
    @id = o["Id"]
    @user_id = o["UserId"]
    @magazine_id = o["MagazineId"]
    @app_prod_id = o["AppProdId"]
    @ext_id = o["ExtId"]
    @groups = o["Groups"]
    @categories = o["Categories"]
    @created_at = o["CreatedAt"]
    @updated_at = o["UpdatedAt"]
    @published_at = o["PublishedAt"]
    @deleted = o["Deleted"]
    @title = o["Title"]
    @description = o["Description"]
    @free = o["Free"]
    @source_ext = o["SourceExt"]
    @published = o["Published"]
    @proc_started_at = o["ProcStartedAt"]
    @proc_state = o["ProcState"]
    @proc_version = o["ProcVersion"]
  end

  def update
    self.instance_variables.each do |name|
      name = name[1..-1]
      if !save_col? name
        next
      end

      value = instance_variable_get '@' + name
      if @orig[name] == value
        next
      end

      @cl.post_retry(
        "auth/dist_edition/#@magazine_id/update/#@id/#{name}",
        { Value:value })
    end
  end

  def upload_pdf(filepath)
    path = "auth/dist_edition/#@magazine_id/upload/#@id/pdf"
    @cl.post_file_retry(path, filepath)
    @has_pdf = true
  end

  def upload_repub(filepath)
    path = "auth/dist_edition/#@magazine_id/upload/#@id/repub"
    @cl.post_file_retry(path, filepath)
  end

  def upload_hpub(filepath)
    path = "auth/dist_edition/#@magazine_id/upload/#@id/hpub"
    @cl.post_file_retry(path, filepath)
  end
end