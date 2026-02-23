# Testing

## Oracle Linux Automation Manager (OLAM) - Wichtige Variablen

### Inventory-Name Variable

Im Oracle Linux Automation Manager (OLAM) wird der Name des Inventars in der folgenden Variable gespeichert:

```
tower_inventory_name
```

Diese Variable gehört zu den sogenannten **Magic Variables**, die von OLAM/AWX automatisch während der Job-Ausführung bereitgestellt werden.

**Beispiel:**
```yaml
- name: Inventory-Name ausgeben
  debug:
    msg: "Das aktuelle Inventory heißt: {{ tower_inventory_name }}"
```
