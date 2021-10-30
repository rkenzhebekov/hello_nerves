defmodule HelloNerves.Assets do
  use Scenic.Assets.Static,
    otp_app: :hello_nerves,
    alias: [
      parrot: "images/cyanoramphus_zealandicus_1849.jpg"
    ]
end
