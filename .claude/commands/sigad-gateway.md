# Gateway YARP Configuration

Configura il Gateway con routing, headers e policies.

## ROUTING
```
/identity/**     → http://localhost:7001/
/tipologiche/**  → http://localhost:7002/
/anagrafiche/**  → http://localhost:7003/
```

## FEATURES
1. **Correlation Id Middleware**
   - Genera X-Correlation-Id se assente
   - Propaga in downstream e response

2. **Authorization Forward**
   - Inoltra header Authorization ai backend

3. **Timeouts**
   - Cluster timeout: 30 secondi

4. **Health Endpoint**
   - GET /health → 200 OK

5. **Swagger Passthrough (DEV-only)**
```
/identity/swagger/**     → http://localhost:7001/swagger/**
/tipologiche/swagger/**  → http://localhost:7002/swagger/**
/anagrafiche/swagger/**  → http://localhost:7003/swagger/**
```

## YARP CONFIG (appsettings.json)
```json
{
  "ReverseProxy": {
    "Routes": {
      "identity-route": {
        "ClusterId": "identity-cluster",
        "Match": { "Path": "/identity/{**catch-all}" },
        "Transforms": [
          { "PathRemovePrefix": "/identity" }
        ]
      }
    },
    "Clusters": {
      "identity-cluster": {
        "Destinations": {
          "destination1": {
            "Address": "http://localhost:7001/"
          }
        },
        "HttpClient": {
          "RequestTimeout": "00:00:30"
        }
      }
    }
  }
}
```

## POST-CHECK
- dotnet build
- Avvio Gateway porta 7100
- Test proxy: curl http://localhost:7100/identity/health
