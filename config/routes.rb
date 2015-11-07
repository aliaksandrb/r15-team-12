Rails.application.routes.draw do
  resources :user_answers
  resources :games do
    member do
      get 'choose_hero'
      post 'start'
      get 'start'
      post 'turn'
      get 'the_end'
    end
  end

  resources :questions
  resources :quizzes

  root 'quizzes#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

# == Route Map
#
#           Prefix Verb   URI Pattern                      Controller#Action
#     user_answers GET    /user_answers(.:format)          user_answers#index
#                  POST   /user_answers(.:format)          user_answers#create
#  new_user_answer GET    /user_answers/new(.:format)      user_answers#new
# edit_user_answer GET    /user_answers/:id/edit(.:format) user_answers#edit
#      user_answer GET    /user_answers/:id(.:format)      user_answers#show
#                  PATCH  /user_answers/:id(.:format)      user_answers#update
#                  PUT    /user_answers/:id(.:format)      user_answers#update
#                  DELETE /user_answers/:id(.:format)      user_answers#destroy
# choose_hero_game GET    /games/:id/choose_hero(.:format) games#choose_hero
#       start_game POST   /games/:id/start(.:format)       games#start
#                  GET    /games/:id/start(.:format)       games#start
#        turn_game POST   /games/:id/turn(.:format)        games#turn
#     the_end_game GET    /games/:id/the_end(.:format)     games#the_end
#            games GET    /games(.:format)                 games#index
#                  POST   /games(.:format)                 games#create
#         new_game GET    /games/new(.:format)             games#new
#        edit_game GET    /games/:id/edit(.:format)        games#edit
#             game GET    /games/:id(.:format)             games#show
#                  PATCH  /games/:id(.:format)             games#update
#                  PUT    /games/:id(.:format)             games#update
#                  DELETE /games/:id(.:format)             games#destroy
#        questions GET    /questions(.:format)             questions#index
#                  POST   /questions(.:format)             questions#create
#     new_question GET    /questions/new(.:format)         questions#new
#    edit_question GET    /questions/:id/edit(.:format)    questions#edit
#         question GET    /questions/:id(.:format)         questions#show
#                  PATCH  /questions/:id(.:format)         questions#update
#                  PUT    /questions/:id(.:format)         questions#update
#                  DELETE /questions/:id(.:format)         questions#destroy
#          quizzes GET    /quizzes(.:format)               quizzes#index
#                  POST   /quizzes(.:format)               quizzes#create
#         new_quiz GET    /quizzes/new(.:format)           quizzes#new
#        edit_quiz GET    /quizzes/:id/edit(.:format)      quizzes#edit
#             quiz GET    /quizzes/:id(.:format)           quizzes#show
#                  PATCH  /quizzes/:id(.:format)           quizzes#update
#                  PUT    /quizzes/:id(.:format)           quizzes#update
#                  DELETE /quizzes/:id(.:format)           quizzes#destroy
#             root GET    /                                quizzes#index
#
