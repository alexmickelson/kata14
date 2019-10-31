defmodule Kata14.BookGenerator do
  def string_to_list({:ok, string}) when is_binary(string) do
    String.split(string)
  end

  def string_to_list(_) do
    {:error, "must provide a string"}
  end

  def process_words({:error, message}) do
    {:error, message}
  end

  def process_words(list, trigram_map \\ %{})

  def process_words([first, second, third | rest], trigram_map)
      when is_map(trigram_map) and is_list(rest) do
    value = Map.get(trigram_map, "#{first} #{second}", [])
    trigram_map = Map.put(trigram_map, "#{first} #{second}", [third | value])
    process_words([second, third | rest], trigram_map)
  end

  def process_words(word_list, trigram_map)
      when is_list(word_list) and is_map(trigram_map) do
    trigram_map
  end

  def make_sentence({:error, message}) do
    {:error, message}
  end

  def make_sentence(trigram_map, word1, word2, count \\ 0) do
    "#{word1} #{word2}#{do_make_sentence(trigram_map, word1, word2, count)}"
  end

  def do_make_sentence(trigram_map, word1, word2, count) when count > 0 do
    case Map.get(trigram_map, "#{word1} #{word2}") do
      third_words when is_list(third_words) ->
        word3 = Enum.random(third_words)
        count = caluclate_sentences_left(word3, count)
        " #{word3}#{do_make_sentence(trigram_map, word2, word3, count)}"
      _ ->
        ""
    end
  end

  def do_make_sentence(_trigram_map, _word1, _word2, _count) do
    ""
  end

  def caluclate_sentences_left(word, count) do
    case String.ends_with?(word, ".") do
      false -> count
      true -> count-1
    end
  end
end
