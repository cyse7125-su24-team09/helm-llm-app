{{/*
Expand the name of the chart.
*/}}
{{- define "rag-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rag-service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rag-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rag-service.labels" -}}
helm.sh/chart: {{ include "rag-service.chart" . }}
{{ include "rag-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rag-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rag-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rag-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rag-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*secret*/}}
{{- define "rag-service.secrets" -}}
{{- with .Values.secrets }}
ES_PASSWORD: {{.ES_PASSWORD | b64enc}}
HUGGINGFACE_TOKEN: {{.HUGGINGFACE_TOKEN | b64enc}}
{{- end }}
{{- end }}


{{/* 
ConfigMap data
*/}}
{{- define "rag-service.configMap" -}}
{{- with .Values.configmap }}
  ES_HOST_URL: {{ .ES_HOST_URL | quote}}
  ES_USERNAME: {{ .ES_USERNAME | quote}}
  APP_PORT: {{ .APP_PORT | quote }}
  ELASTICSEARCH_INDEX: {{ .ELASTICSEARCH_INDEX  | quote }}
  LLM_SERVER_URL: {{ .LLM_SERVER_URL | quote }}
{{- end }}
{{- end }}
