defmodule Pento.Promo.Recipient do
  # the attributes
  defstruct [:first_name, :email]
  # a map of types needed by the changeset
  @types %{first_name: :string, email: :string}

  import Ecto.Changeset

  # 1st argument is the Promo.Recipient struct
  # __MODULE__ macro evaluates to name of the current module
  # which is pattern matched to user
  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
