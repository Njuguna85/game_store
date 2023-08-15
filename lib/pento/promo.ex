defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  # creates a recipient changeset
  # the public changeset api below will
  # only be activated if a recipient struct is passed
  # with some attributes or not
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(_recipient, _attrs) do
    # TODO: send email to promo recipient
    {:ok, %Recipient{}}
  end
end
