module BoggleError
  class InvalidDictionaryWordError < StandardError
    def message
      "The submitted word is not a valid word."
    end
  end

  class WordTooShortError < StandardError
    def message
      "The submitted word needs to have at least 3 characters."
    end
  end

  class WordNotPossibleFromBoardError < StandardError
    def message
      "The submitted word cannot made using the letters in the current board."
    end
  end
end