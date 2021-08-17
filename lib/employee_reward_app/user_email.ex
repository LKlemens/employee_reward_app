defmodule EmployeeRewardApp.UserEmail do
  import Swoosh.Email

  def create(email, body) do
    name = get_name(email)

    new()
    |> to({name, email})
    |> from({"EmployeeRewardApp", get_from_email()})
    |> subject("Please verify your EmployeeRewardApp account")
    |> text_body(body)
  end

  defp get_name(email) do
    email
    |> String.split(~r/@/)
    |> List.first()
  end

  defp get_from_email do
    Application.get_env(:employee_reward_app, EmployeeRewardApp.Mailer)
    |> Keyword.get(:from_email)
  end
end
