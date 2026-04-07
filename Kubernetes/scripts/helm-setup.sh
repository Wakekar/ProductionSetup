#!/bin/bash

kubectl create namespace monitoring || true
kubectl create namespace sonarqube || true
kubectl create namespace nexus || true

# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

# SonarQube
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
helm install sonarqube sonarqube/sonarqube -n sonarqube

# Nexus
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm repo update
helm install nexus sonatype/nexus-repository-manager -n nexus
