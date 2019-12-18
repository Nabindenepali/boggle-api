class BoggleController < ApplicationController
  # GET /boggle/new-game
  def new_game
    @board = Board.find(Board.pluck(:id).sample)
    json_response({board_id: @board.id, board: @board.dices})
  end

  # GET /boggle/:board_id/submit-word/:word
  def submit_word
    @board = Board.find(params[:board_id])
    if params[:word].size < 3 # if the word is too short
      raise BoggleError::WordTooShortError
    end
    unless speller.correct?(params[:word]) # if the word is invalid
      raise BoggleError::InvalidDictionaryWordError
    end
    unless valid_word_for_board?(JSON.parse(@board.dices), params[:word]) # if the word can't be made from the board
      raise BoggleError::WordNotPossibleFromBoardError
    end
    json_response({score: get_score_for_word(params[:word])})
  end

  private

  # check if the word is valid for the board
  def valid_word_for_board?(letters, word)
    letters.each_with_index do |row, i|
      row.each_with_index do |letter, j|
        if word[0] == letter
          if make_word_from_board?(letters, word, i, j)
            return true
          end
        end
      end
    end
    false
  end

  # try to make specified word with given letters starting from the specified position
  def make_word_from_board?(letters, word, i, j)
    matched_dices = []
    unmatched_dices = []
    letter_used = letters.map {|column| column.map { false }}
    letter_used[i][j] = true
    matched_dices.push([i, j])
    word_pos = 1
    while word_pos < word.size
      letter_matched = false
      # move a step next to the current letter to check if we can form the word
      (i-1..i+1).each do |m|
        # ignore if our matching window is outside the dices
        if m == -1 || m == letters.size
          next
        end
        (j-1..j+1).each do |n|
          # ignore if our matching window is outside the dices
          if n == -1 || n == letters[0].size
            next
          end
          # ignore for the central dice
          if m == i && n == j
            next
          end
          # ignore if letter at the position has already been used
          if letter_used[m][n]
            next
          end
          # skip if the dice is already unmatched
          if unmatched_dices.find{|dice| dice[0] == m && dice[1] == n}
            next
          end
          if letters[m][n] == word[word_pos]
            i = m
            j = n
            letter_matched = true
            letter_used[i][j] = true
            matched_dices.push([i, j])
            break
          end
        end
        if letter_matched
          word_pos += 1
          break
        end
      end
      unless letter_matched
        # return false when only a single letter is matching
        if word_pos == 1
          return false
        end
        word_pos -= 1
        # get the last matched dice
        i, j = matched_dices.pop
        letter_used[i][j] = false
        unmatched_dices.push([i, j])
      end
    end
    true
  end

  # get boggle scores based on word length
  def get_score_for_word(word)
    word.length >= 3 ? word.length : 0
  end
end
