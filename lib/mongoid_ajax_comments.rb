module MongoidAjaxComments
  def self.commentables
    @commentables || []
  end

  def self.commentables=(new_commentables)
    @commentables = new_commentables
  end

  def self.guards
    @guards ||= {}
  end

  module AttachableModel
    def self.included(base)
      base.send :field, :file_uid
      base.send :validates_presence_of, :file
    end
  end

  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
    initializer "dragonfly installation" do |app|
      require 'dragonfly'
      dapp = Dragonfly[:comment_attachments]

      cfg = YAML.load_file(Rails.root.join('config/mongoid.yml'))[Rails.env]

      dapp.configure_with(:rails) do |c|
        c.datastore = Dragonfly::DataStorage::MongoDataStore.new( :database => cfg['database'],
                                                                  :host => cfg['host'],
                                                                  :port => cfg['port'],
                                                                  :username => cfg['username'],
                                                                  :password => cfg['password'] )
      end

      dapp.define_macro_on_include(AttachableModel, :image_accessor)

      app.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :comment_attachments
      app.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
       :verbose     => false,
       :metastore   => "file:#{Rails.root}/tmp/dragonfly/cache_comment_attachments/meta",
       :entitystore => "file:#{Rails.root}/tmp/dragonfly/cache_comment_attachments/body"
       }
    end
  end
end
