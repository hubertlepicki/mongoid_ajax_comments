module MongoidAjaxComments
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
    end
  end
end
