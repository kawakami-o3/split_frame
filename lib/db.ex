defmodule Repo do
  use Ecto.Repo, otp_app: :split
end

defmodule User do
  use Ecto.Schema
  schema "user" do
  #    field :id, :integer
  #@primary_key {:id, :id, autogenerate: true}
    field :name, :string
  end
end


defmodule Db do
  import Ecto.Query
  #use Application
  require Logger

  # crud
 
  def serve(socket) do
    params = socket |> Server.read_line() |> String.trim |> String.split
    case params do
      ["c",name] -> create(name)
      ["r",id] -> Logger.info "c"
      ["u",id,name] -> Logger.info "c"
      ["d",id] -> Logger.info "c"
      _ -> IO.inspect params
    end
  end

  defp create(name) do
    IO.inspect name
    Logger.info "create"

    Repo.start_link
    #res = Repo.insert %User{name: name}
    res = Repo.insert! %User{name: name}

    #query = from u in User
    #res = Repo.all(query)
    IO.inspect res
  end

  defp read(id) do
    query = from u in User,
      where: u.id == ^id,
      select: u

    [res] = Repo.all(query)

    IO.inspect res
  end

  defp update(name) do
  end

  defp delete(name) do
  end
end

