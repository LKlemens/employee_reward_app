defmodule EmployeeRewardApp.TimeManipulation do
  def now do
    Timex.now()
  end

  def update_date("prev", date) do
    Timex.shift(date, months: -1)
  end

  def update_date("next", date) do
    Timex.shift(date, months: 1)
  end

  def format_date(date) do
    case Timex.format(date, "{YYYY} {Mfull}") do
      {:ok, formated_date} ->
        formated_date

      _ ->
        date
    end
  end
end
