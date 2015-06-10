[
  mappings: [
    "listen": [
      doc: """
      API endpoint in form of <protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http

      It is possible to specify port as 0 or * to using only mdns registration
      """ ,
      to: "hello_router.listen",
      datatype: :charlist,
      default: "zmq-tcp://127.0.0.1:20000"
    ],
    "route.*": [
      to: "hello_router.routes",
      datatype: [:complex],
      default: []
    ],
    "route.*.pattern": [
      doc: "API prefix pattern",
      to: "hello_router.routes",
      datatype: :binary,
      default: "APIPrefix"
    ],
    "route.*.target": [
      doc: "Route API endpoint in form of <protocol>://<host>[:<port>]",
      to: "hello_router.routes",
      datatype: :string,
      default: "http://127.0.0.1:8080"
    ]
  ],
  translations: [
    "hello_router.routes.*": fn _, {key, value_map}, acc ->
      [{value_map[:pattern], value_map[:target]} | acc]
    end,
    "listen": fn
      _, uri, acc ->
        try do
          :ex_uri.decode(uri)
          uri
        catch
          _, _ ->
            IO.puts("Unsupported URI format: #{uri}")
            exit(1)
        end
    end
  ]
]
