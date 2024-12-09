cache.size = 10 * MB

modules = {
	"policy",
	"serve_stale < cache",
	"stats",
	"predict",
	"http",
	"dnstap",
}

http.config({ tls = false })
http.prometheus.namespace = "kresd_"

net.listen("127.0.0.1", 8453, { kind = "webmgmt" })

function splitoff(name, server)
	dnames = policy.todnames({ name })

	policy.add(policy.suffix(policy.FLAGS({ "NO_CACHE" }), dnames))

	policy.add(policy.suffix(policy.STUB(server), dnames))
end

splitoff("lan", "127.0.0.1@5353")
splitoff(".pig-crested.ts.net", "100.100.100.100")

policy.add(policy.all(policy.STUB("1.1.1.1")))

dnstap.config({
	socket_path = "/run/splitbrain/dnstap",
	client = { log_responses = true },
})
