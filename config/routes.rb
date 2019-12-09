Rails.application.routes.draw do
  scope '/boggle' do
    get '/new-game', to: 'boggle#new_game'
    get '/:board_id/submit-word/:word', to: 'boggle#submit_word'
  end
end
