{{/*
Return the fullname of the frontend
*/}}
{{- define "iracelog-app.frontend.fullname" -}}
{{- printf "%s-frontend" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{/*
Return the fullname of the ism (iracelog-service-manager)
*/}}
{{- define "iracelog-app.ism.fullname" -}}
{{- printf "%s-ism" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{/*
Return the fullname of the graphl component
*/}}
{{- define "iracelog-app.graphql.fullname" -}}
{{- printf "%s-graphql" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iracelog-app.fullname" -}}
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
{{- define "iracelog-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iracelog-app.labels" -}}
helm.sh/chart: {{ include "iracelog-app.chart" . }}
{{ include "iracelog-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iracelog-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iracelog-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iracelog-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iracelog-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Return the proper image name.
This variant is used when image versions are stored in a single attribute instead of imageRoot.tag
If image tag and digest are not defined, termination fallbacks to imageVersion and chart appVersion.
{{ include "iracelog-app.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global "imgVersion" .Values.path.to.the.version "chart" .Chart ) }}
*/}}
{{- define "iracelog-app.images.image" -}}
{{- $registryName := default .imageRoot.registry ((.global).imageRegistry) -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}

{{- if not .imageRoot.tag }}
  {{- if .imgVersion -}}
    {{- $termination = .imgVersion | toString -}}
  {{- else -}}
    {{- if .chart }}
        {{- $termination = .chart.AppVersion | toString -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}


{{- define "frontend.image" -}}
{{ include "iracelog-app.images.image" (dict "imageRoot" .Values.frontend "global" .Values.global "imgVersion" .Values.iracelogVersion ) }}
{{- end -}}

{{- define "ism.image" -}}
{{ include "iracelog-app.images.image" (dict "imageRoot" .Values.ism "global" .Values.global "imgVersion" .Values.ismVersion ) }}
{{- end -}}

{{- define "graphql.image" -}}
{{ include "iracelog-app.images.image" (dict "imageRoot" .Values.graphql "global" .Values.global "imgVersion" .Values.graphqlVersion ) }}
{{- end -}}
