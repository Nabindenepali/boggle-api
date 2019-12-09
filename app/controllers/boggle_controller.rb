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
          # ignore if our matching window is outside the dices and also for the current dice
          if n == -1 || n == letters[0].size || (m == i && n == j)
            next
          end
          if letters[m][n] == word[word_pos]
            word_pos += 1
            i = m
            j = n
            letter_matched = true
            break
          end
        end
        if letter_matched
          break
        end
      end
      unless letter_matched
        return false
      end
    end
    true
  end

  # get boggle scores based on word length
  def get_score_for_word(word)
    if word.length < 3
      return 0
    end
    case word.length
    when 3
      return 1
    when 4
      return 1
    when 5
      return 2
    when 6
      return 3
    when 7
      return 5
    else
      return 11
    end
  end
end
