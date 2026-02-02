{{- define "parlay.labels" -}}
app.kubernetes.io/name: parlay-analyzer
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
