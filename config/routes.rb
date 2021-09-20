Rails.application.routes.draw do
  # mount_devise_token_auth_for "User", at: "auth"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # namespace :●● do ルーティングの定義に名前空間を付ける
  # この場合だと app/controllers/api/v1/articles_controller.rb の
  # Api::V1::ArticlesControllerが呼び出される
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth"
      resources :articles
    end
  end
end
