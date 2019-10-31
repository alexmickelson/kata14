defmodule Commandline.CLI do
  alias Kata14.BookGenerator
  def main(opts \\ []) do
    {options, _, _} = OptionParser.parse(opts,
      switches: [file: :string, sentences: :integer]
    )
    # :rand.uniform(10)
    text_file = Keyword.get(options, :file, "sherlock.txt")
    num_sentence = Keyword.get(options, :sentences, 1)
    
    {microseconds, text} = :timer.tc(Commandline.CLI, :do_main, [text_file, num_sentence])
    
    IO.inspect text
    IO.inspect "seconds: #{microseconds/1_000_000}"
  end
  
  def do_main(text_file, num_sentence) do
    File.read(text_file)
    |> BookGenerator.string_to_list
    |> BookGenerator.process_words
    |> BookGenerator.make_sentence( "I", "have", num_sentence)
  end
  
end
