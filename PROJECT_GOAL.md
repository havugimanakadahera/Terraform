# 🚀 Infrastructure Transformation Roadmap
**Multi-Repo Terraform Deployment: 3-Week Timeline**

> ⚠️ **DRAFT DOCUMENT** — For INFRA Team Review & Completion  
> ✅ **No other releases scheduled during deployment windows**

## Goal
Replace broken monolithic Terraform (2024 onwards) with modular multi-repository architecture across 6 environments (INT, QA, UAT, STG, PRD, MIR).

**Components:** KVSB (KeyVault+ServiceBus) ✅ | Monitoring (Grafana+Prometheus) ✅ | Storage (DB+Redis) ✅  
**Approach:** Deploy each component to each environment sequentially. Same config per environment (names differ only).  
**Duration:** 3 weeks (May 15-23, 2026)

## Timeline (Quick View)

| Date | Environment | Components | Window | Status |
|------|-------------|-----------|--------|--------|
| **May 15** | Review Phase | All | Full day | Fix issues, validate tfvars |
| **May 16** | **INT** | KVSB, Monitoring, Storage | 09:00-18:00 | ← First production test |
| **May 17 AM** | **QA** | KVSB, Monitoring, Storage | 09:00-12:00 | ← Validate INT success |
| **May 17 PM** | **UAT** | KVSB, Monitoring, Storage | 14:00-17:00 | ← Ready for STG |
| **May 18** | **STG + MIR** | KVSB, Monitoring, Storage | 09:00-17:00 | ← Mirror production pattern |
| **May 23** | **PRD** | KVSB, Monitoring, Storage | 09:00-15:00 | ← Go-live (if no issues) |

---

## Component Status

| Component | Status | Ready? |
|-----------|--------|--------|
| KVSB (KeyVault & Service Bus) | ✅ Ready to deploy | YES |
| Monitoring (Grafana & Prometheus) | ✅ Ready to deploy | YES |
| Storage (DB & Redis) | ✅ Ready to deploy | YES |
| Kubernetes | 🔄 Construction ongoing | LATER |
| Network | 🔍 Analysis phase | LATER |

---

## Weekly Breakdown

### Week 1: Prep & INT (May 15-16)

**May 15 - Issue Resolution**
- Review all tfvars for placeholders
- Validate naming conventions
- Fix environment-specific configs
- Sign-off on plan output

**May 16 - INT Deployment**
```
09:00 - Plan all 3 components (review)
09:30 - Apply: KVSB
10:30 - Apply: Monitoring  
11:30 - Apply: Storage
12:30 - Smoke tests
14:00 - Complete
```

### Week 2: Progression (May 17-18)

**May 17 Morning - QA**
- Plan all 3 components
- Apply if INT successful
- Validate matches INT

**May 17 Afternoon - UAT**
- Same process as QA

**May 18 Full Day - STG + MIR**
- Deploy STG
- Re-deploy MIR (sync with production)

### Week 3: Go-Live (May 23)

**May 23 - PRD Deployment**
- Final plan review
- User approval required
- Apply all 3 components
- Full smoke tests
- ✅ Complete

---

## Environment Configuration Differences
**To be completed by INFRA Team — Add actual values per environment**

### Component: KVSB (KeyVault & Service Bus)

| Configuration | INT | QA | UAT | STG | MIR | PRD | Notes |
|---|---|---|---|---|---|---|---|
| **KeyVault Name** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., kv-int-app |
| **KeyVault SKU** | Standard | Standard | Standard | Standard | Standard | Premium | Adjust as needed |
| **Service Bus Namespace** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., sb-int-app |
| **Service Bus SKU** | Standard | Standard | Standard | Standard | Standard | Premium | INT/QA/UAT can start Standard |
| **Replication** | Local | Local | Local | Local | Local | Zone-redundant | PRD requires HA |
| **Access Policies** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | Team names / principals |
| **Encryption** | Service-managed | Service-managed | Service-managed | Service-managed | Service-managed | Customer-managed | PRD security |
| **Backup Enabled** | No | No | No | No | No | Yes | PRD only initially |
| **Monitoring Alert** | Basic | Basic | Basic | Basic | Basic | Full | PRD full alerting |

**INFRA Team To-Do:**
- [ ] Fill in actual resource names per environment
- [ ] Confirm SKU levels match business requirements
- [ ] Identify which teams get access policies per environment
- [ ] Verify encryption requirements with security team

---

### Component: Monitoring (Grafana & Prometheus)

| Configuration | INT | QA | UAT | STG | MIR | PRD | Notes |
|---|---|---|---|---|---|---|---|
| **Grafana Instance Name** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., grafana-int |
| **Grafana Compute Size** | T2 Small | T2 Small | T2 Medium | T2 Medium | T2 Medium | T3 Large | Scale per env |
| **Prometheus Storage Name** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., prom-int-storage |
| **Prometheus Storage Size** | 10 GB | 10 GB | 50 GB | 100 GB | 100 GB | 500 GB | Adjust retention |
| **Scrape Interval** | 60s | 60s | 30s | 30s | 30s | 15s | More frequent for PRD |
| **Metrics Retention** | 7 days | 7 days | 30 days | 30 days | 30 days | 90 days | Compliance requirement |
| **Dashboard Count Target** | 5 | 5 | 10 | 15 | 15 | 20 | Plan dashboards |
| **Alert Rules Count** | 10 | 10 | 20 | 30 | 30 | 50 | PRD comprehensive |
| **Log Aggregation** | Basic | Basic | Standard | Standard | Standard | Full | ELK / Splunk |
| **Data Export Enabled** | No | No | No | Yes | Yes | Yes | STG+ can export |

**INFRA Team To-Do:**
- [ ] Confirm storage size matches data retention policy
- [ ] List specific dashboards needed per environment
- [ ] Identify alert rule priorities
- [ ] Plan log aggregation strategy (Splunk / ELK / Azure Monitor)
- [ ] Confirm backup/export requirements

---

### Component: Storage (PostgreSQL Database & Redis Cache)

| Configuration | INT | QA | UAT | STG | MIR | PRD | Notes |
|---|---|---|---|---|---|---|---|
| **PostgreSQL Server Name** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., db-int-pg |
| **PostgreSQL Version** | 11 | 11 | 12 | 14 | 14 | 15 | Plan version progression |
| **PostgreSQL SKU** | B_Gen5_1 | B_Gen5_2 | B_Gen5_2 | D_Gen5_4 | D_Gen5_4 | E_Gen5_8 | Scale per env |
| **Database Name(s)** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | List all databases |
| **Backup Retention** | 7 days | 7 days | 14 days | 30 days | 30 days | 90 days | Adjust per policy |
| **Geo-Replication** | Off | Off | Off | On | On | On | Disaster recovery |
| **Failover Region** | N/A | N/A | N/A | [ ] | [ ] | [ ] | e.g., East US 2 |
| **SSL Enforcement** | Yes | Yes | Yes | Yes | Yes | Yes | Security requirement |
| **Public Network Access** | Restricted | Restricted | Restricted | Restricted | Restricted | Off | PRD private only |
| **Redis Cache Name** | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | e.g., redis-int-cache |
| **Redis Tier** | Basic | Basic | Standard | Standard | Standard | Premium | Clustering in PRD |
| **Redis Size** | 1 GB | 2 GB | 6 GB | 13 GB | 13 GB | 26 GB | Cache scaling |
| **Redis Version** | 6.x | 6.x | 6.x | 7.x | 7.x | 7.x | Upgrade timeline |
| **Redis Persistence** | None | None | RDB | RDB | RDB | AOF | PRD append-only |
| **Redis Replication** | Disabled | Disabled | Disabled | Enabled | Enabled | Enabled | High availability |
| **Database Connection Pool** | 20 | 30 | 50 | 100 | 100 | 200 | Adjust per load |

**INFRA Team To-Do:**
- [ ] Confirm database names and initial schemas
- [ ] Verify version compatibility with applications
- [ ] Determine backup retention per compliance
- [ ] Plan geo-replication failover procedures
- [ ] Confirm Redis persistence strategy
- [ ] Set up database migration tests (version upgrades)
- [ ] Document connection pool requirements per environment

---

### Expected Plan Output (All Environments)

**KVSB Module:**
```
terraform plan output:
  + 1 resource to add: azurerm_key_vault.main
  + 1 resource to add: azurerm_service_bus.main
Plan: 2 to add, 0 to change, 0 to destroy
```
✅ Expected for all environments (resource names differ, config patterns match)

**Monitoring Module:**
```
terraform plan output:
  + 1 resource to add: azurerm_container_instance.grafana
  + 1 resource to add: azurerm_storage_account.prometheus
Plan: 2 to add, 0 to change, 0 to destroy
```
✅ Expected for all environments

**Storage Module:**
```
terraform plan output:
  + 1 resource to add: azurerm_postgresql_server.main
  + 1 resource to add: azurerm_redis_cache.main
Plan: 2 to add, 0 to change, 0 to destroy
```
✅ Expected for all environments (may show changes if versions differ)

---

### Configuration Validation Checklist (Per Environment)

**To be verified by INFRA Team before each deployment:**

#### INT
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

#### QA
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

#### UAT
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

#### STG
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

#### MIR
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

#### PRD
- [ ] KeyVault name: _______________
- [ ] Service Bus namespace: _______________
- [ ] Grafana instance: _______________
- [ ] PostgreSQL version: _____ SKU: _____
- [ ] Redis size: _____ GB
- [ ] All values tested and working

---

## Pre-Deployment Checklist

- [ ] All tfvars files finalized (no placeholders)
- [ ] `terraform plan` generates no errors
- [ ] Resource quotas verified in Azure
- [ ] No other releases scheduled during deployment
- [ ] Rollback procedure documented
- [ ] On-call team notified

---

## Common Issues & Quick Fixes

| Issue | Symptom | Fix |
|-------|---------|-----|
| State Lock | `resource temporarily unavailable` | `terraform force-unlock <LOCK_ID>` |
| Naming Conflict | `resource with ID already exists` | Add timestamp suffix to resource names |
| DB Version | `PostgreSQL 11 doesn't support feature` | Use consistent versions across INT/QA/UAT |
| Redis Eviction | `MISCONF Redis is configured to save` | Resize in maintenance window, monitor memory |

---

## Success Criteria

✅ Per environment, verify:
- [ ] All resources created successfully
- [ ] KeyVault accessible from applications
- [ ] Monitoring dashboards populated
- [ ] Database accepts connections
- [ ] Redis cluster healthy
- [ ] No alerts firing (unless intentional)
- [ ] Backup/retention policies active

---

## Communication

### Before Deployment (T-24h)
```
TO: Digital Release Manager, INFRA Team
SUBJECT: [INFRA] Terraform Deployment - [Environment] on [Date]

Window: [Time] - [Time]
Environment: [INT/QA/UAT/STG/MIR/PRD]
Components: KVSB, Monitoring, Storage
No other releases scheduled during this window.
```

### After Deployment (T+2h)
```
Status: ✅ SUCCESS
All components deployed and tested
Sign-off: [Names]
Ready for next environment.
```

---

**Document Status:** 🟡 DRAFT (For INFRA Team Review & Completion)  
**Version:** 1.0  
**Date:** May 18, 2026

