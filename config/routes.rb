Rails.application.routes.draw do |map|
  get ":commentable_type/:commentable_id/comments", to: "comments#index", as: "comments"
  get ":commentable_type/:commentable_id/comments/new", to: "comments#new", as: "new_comment"
  put ":commentable_type/:commentable_id/comments", to: "comments#create"
  get ":commentable_type/:commentable_id/comments/:id/edit", to: "comments#edit", as: "edit_comment"
  post ":commentable_type/:commentable_id/comments/:id", to: "comments#update", as: "comment"
end
