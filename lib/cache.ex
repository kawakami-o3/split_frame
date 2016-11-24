defmodule Cache do
  require Logger

 
  def serve(socket) do
    params = socket |> Server.read_line() |> String.trim |> String.split
    case params do
      ["s",key,value] -> Logger.info(create(key,value))
      ["g",key] -> Logger.info(read(key))
      _ -> IO.inspect params
    end
  end

  defp create(key,value) do
    Logger.info "kjlj"
    response = Memcache.Client.set(key, value)
    case response.status do
      :ok -> {:ok, response.cas}
      status -> {:error, status}
      #:ok -> return response.cas
      #status -> IO.inspect status
    end
    response.value
  end

  defp read(key) do
    response = Memcache.Client.get(key)
    case response.status do
      :ok -> {:ok, response.value}
      status -> {:error, status}
      #:ok -> return response.value
      #status -> IO.inspect status
    end
    #response
    #"-"
    response.value
  end

end

