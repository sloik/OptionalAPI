import OptionalAPI

func example(payloadData: Data?) {
    let decoded: Payload? = payloadData.decode()
    _ = decoded
}
