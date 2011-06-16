Rails.application.routes.draw do |map|
  get ":commentable_type/:commentable_id/comments", to: "comments#index", as: "comments"
  get ":commentable_type/:commentable_id/comments/new", to: "comments#new", as: "new_comment"
  get ":commentable_type/:commentable_id/comments/:id/edit", to: "comments#edit", as: "edit_comment"
  get ":commentable_type/:commentable_id/comments/:id", to: "comments#show", as: "comment"
  post ":commentable_type/:commentable_id/comments/:id", to: "comments#update"
  put ":commentable_type/:commentable_id/comments", to: "comments#create"
  delete ":commentable_type/:commentable_id/comments/:id", to: "comments#destroy"
end
