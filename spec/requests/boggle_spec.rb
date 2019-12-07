require 'rails_helper'

RSpec.describe 'Boggle API', type: :request do
  # initialize test data for boards
  let!(:boards) { create_list(:board, 5) }
  let(:board_id) { boards.first.id }
  let(:word) { 'TRACK' }

  # Test suite for GET /boggle/new-game
  describe 'GET /boggle/new-game' do
    before { get '/boggle/new-game' }

    it 'returns a single board of size 4X4' do
      expect(json).not_to be_empty
      expect(json['board'].size).to eq(4)
      expect(json['board'][0].size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /boggle/submit-word/:board_id/:word
  describe 'GET /boggle/submit-word/:board_id/:word' do
    before { get "/boggle/submit-word/#{board_id}/#{word}" }

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
            expect(response.body).to match(/The given word can't be made from the letters in the board/)
          end

          it 'returns status code 400' do
            expect(response).to have_http_status(422)
          end
        end
      end

      context 'when the word specified is an invalid word' do
        let(:word) { 'BAMBINO' }

        it 'returns a word not found message' do
          expect(response.body).to match(/The given word wasn't found in our dictionary/)
        end

        it 'returns status code 400' do
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'when the board does not exist' do
      let(:board_id) { 100 }

      it 'returns a not found message' do
        expect(response.body).to match(/The board with given id doesn't exist/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end