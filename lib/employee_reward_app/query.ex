defmodule EmployeeRewardApp.Query do
  defmacro __using__(_opts \\ []) do
    quote do
      import Ecto
      import Ecto.Query
      import unquote(__MODULE__)
    end
  end

  defmacro date_part(text, timestamp) do
    surrounded_text = "'" <> text <> "'"
    command = "date_part(" <> surrounded_text <> ", ?)"
    quote do: fragment(unquote(command), unquote(timestamp))
  end
end
