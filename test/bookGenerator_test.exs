defmodule Kata14.BookGeneratorTest do
  use ExUnit.Case

  alias Kata14.BookGenerator

  describe "string_to_list/1" do
    test "split string by spaces" do
      string = "string with spaces"
      expected = ["string", "with", "spaces"]
      assert expected == BookGenerator.string_to_list({:ok, string})
    end

    test "returns error when given inalid args" do
      expected = {:error, "must provide a string"}
      assert expected == BookGenerator.string_to_list([0, 2, 3])
    end
  end

  describe "process_words/1" do
    test "passes errors along" do
      error = {:error, "error message"}
      actual = BookGenerator.process_words(error)
      assert error == actual
    end

    test "does nothing at end of list" do
      actual = BookGenerator.process_words(["last."])
      assert %{} == actual
    end

    test "sorts word passed in" do
      args = ["this", "was", "passed"]
      expected = %{"this was" => ["passed"]}
      actual = BookGenerator.process_words(args)
      assert expected == actual
    end

    test "handles four words" do
      args = ["this", "was", "also", "passed"]

      expected = %{
        "this was" => ["also"],
        "was also" => ["passed"]
      }

      assert expected == BookGenerator.process_words(args)
    end

    test "appends onto existing word maps" do
      word_list = ["this", "was", "passed"]
      existing_map = %{
        "this was" => ["that"]
      }
      expected = %{
        "this was" => ["passed", "that"]
      }
      assert expected == BookGenerator.process_words(word_list, existing_map)
    end
  end

  describe "integrate string_to_list with process_words" do
    test "integration 1" do
      text = "I wish I may I wish I might"
      actual =
        BookGenerator.string_to_list({:ok, text})
        |> BookGenerator.process_words()
      expected = %{
        "I wish" => ["I", "I"],
        "wish I" => ["might", "may"],
        "may I" => ["wish"],
        "I may" => ["I"]
      }
      assert expected == actual
    end
  end

  describe "make_sentence/1" do
    test "passes errors" do
      error = {:error, "error message"}
      assert error == BookGenerator.make_sentence(error)
    end
    test "stops on empty path" do
      trigram_map = %{
        "one two" => ["three"],
        "two three" => ["four"]
      }
      expected = "one two three four"
      assert expected == BookGenerator.make_sentence(trigram_map, "one", "two", 1)
    end
    test "stops at period" do
      trigram_map = %{
        "one two" => ["three."],
        "two three." => ["four"]
      }
      expected = "one two three."
      assert expected == BookGenerator.make_sentence(trigram_map, "one", "two", 1)
    end
    test "makes two sentences" do
      trigram_map = %{
        "one two" => ["three."],
        "two three." => ["four"]
      }
      expected = "one two three. four"
      assert expected == BookGenerator.make_sentence(trigram_map, "one", "two", 2)
    end
  end

end
