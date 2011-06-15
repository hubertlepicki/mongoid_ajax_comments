class ActiveSupport::CleanCase < ActiveSupport::TestCase
  setup do
    Mongoid.master.collections.select {|c| c.name !~ /system|fs\./}.each(&:drop)
  end
end
