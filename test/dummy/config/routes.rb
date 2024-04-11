Rails.application.routes.draw do
  get("up" => "rails/health#show", :as => :rails_health_check)

  match("/:page" => "pages#show", :as => :page, :via => :get)

  root("pages#index")
end
