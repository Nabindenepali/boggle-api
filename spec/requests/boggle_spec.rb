require 'rails_helper'

RSpec.describe 'Boggle API', type: :request do
  # initialize test data for boards
  let!(:boards) { create_list(:board, 5) }
  let(:board_id) { boards.first.id }
  let(:word) { 'TRACK' }

  # Test suite for GET /boggle/new-game
  describe 'GET /boggle/new-game' do
    before { get '/boggle/new-game' }

    it 'returns a board as json object' do
      expect(json).not_to be_empty
    end

    it 'returns the id of the board as board_id' do
      expect(json['board_id']).not_to be_nil
    end

    it 'returns a board of size 4X4' do
      expect(json['board']).not_to be_nil
      expect(JSON(json['board']).size).to eq(4)
      expect(JSON(json['board'])[0].size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /boggle/:board_id/submit-word/:word
  describe 'GET /boggle/:board_id/submit-word/:word' do
    before { get "/boggle/#{board_id}/submit-word/#{word}" }

    context 'when the board exists' do
      context 'when the word specified is a valid word' do
        context 'when the word can be made from letters in the board' do
          it 'returns the score for the word' do
            expect(json).not_to be_empty
            expect(json['score']).to eq(2) # Boggle scores 2 for 5-letter words
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'when the word cannot be made from letters in the board' do
          let(:word) { 'ANOTHER' }

          it 'returns a word cannot be made from the board message' do
            expect(response.body).to match(/The submitted word cannot made using the letters in the current board/)
          end

          it 'returns status code 400' do
            expect(response).to have_http_status(400)
          end
        end
      end

      context 'when the word specified is less than 3 characters' do
        let(:word) { 'BE' }

        it 'returns a word too short message' do
          expect(response.body).to match(/The submitted word needs to have at least 3 characters/)
        end

        it 'returns status code 400' do
          expect(response).to have_http_status(400)
        end
      end

      context 'when the word specified is an invalid word' do
        let(:word) { 'BAMBINO' }

        it 'returns a word not found message' do
          expect(response.body).to match(/The submitted word is not a valid word/)
        end

        it 'returns status code 400' do
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'when the board does not exist' do
      let(:board_id) { 100 }

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end