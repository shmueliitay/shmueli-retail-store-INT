{{/*
Return the chart name
*/}}
{{- define "retail-store-ui.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/*
Return the release name
*/}}
{{- define "retail-store-ui.release" -}}
{{- .Release.Name -}}
{{- end -}}

{{/*
Return the fully qualified app name
*/}}
{{- define "retail-store-ui.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the ServiceAccount name
*/}}
{{- define "retail-store-ui.serviceAccountName" -}}
{{- printf "%s-sa" (include "retail-store-ui.fullname" .) -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "retail-store-ui.labels" -}}
app.kubernetes.io/name: {{ include "retail-store-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Aliases for old templates using store-ui.* */}}
{{- define "store-ui.fullname" -}}
{{- include "retail-store-ui.fullname" . -}}
{{- end -}}

{{- define "store-ui.serviceAccountName" -}}
{{- include "retail-store-ui.serviceAccountName" . -}}
{{- end -}}

{{- define "store-ui.labels" -}}
{{- include "retail-store-ui.labels" . -}}
{{- end -}}

