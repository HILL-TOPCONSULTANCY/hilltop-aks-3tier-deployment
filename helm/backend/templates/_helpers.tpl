{{- define "backend.name" -}}
backend
{{- end -}}

{{- define "backend.fullname" -}}
{{ .Release.Name }}-backend
{{- end -}}

{{- define "backend.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "{{ .Chart.AppVersion | default "1.0.0" }}"  # Ensure it's always a string
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
