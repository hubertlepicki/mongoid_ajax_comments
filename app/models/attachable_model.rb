module AttachableModel
  def self.included(base)
    base.send :field, :file_uid
    base.send :validates_presence_of, :file
  end
end
