import relationalStore from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import Logger from './Logger'
import { ColumnInfo, ColumnType } from '../bean/ColumnInfo'

const DB_FILENAME: string = 'Healthy.db'

class DbUtil {
  rdbStore: relationalStore.RdbStore

  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config).then((store) => {
        this.rdbStore = store
        Logger.debug('rdbStore init success')
        resolve()
      }).catch((err) => {
        Logger.error('rdbStore init failed', JSON.stringify(err))
        reject(err)
      })
    })
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.rdbStore.executeSql(createSQL).then((result) => {
        Logger.debug('create table success')
        resolve()
      }).catch((err) => {
        Logger.error('create table failed', JSON.stringify(err))
        reject(err)
      })
    })
  }

  insert(tableName: string, obj: any, columns: ColumnInfo[]) {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns)
      this.rdbStore.insert(tableName, value, (err, id) => {
        if (err) {
          Logger.error('insert failed', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('insert success id= ', id.toString())
          resolve(id)
        }
      })
    })
  }

  buildValueBucket(obj: any, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    let value = {}
    columns.forEach((column) => {
      if (typeof obj !== 'undefined') {
        value[column.columnName] = obj[column.name]
      }
    })
    return value
  }

  delete(predicates: relationalStore.RdbPredicates) {
    return new Promise((resolve, reject) => {
      this.rdbStore.delete(predicates, (err, rows) => {
        if (err) {
          Logger.error('delete failed', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('delete success rows = ', rows.toString())
          resolve(rows)
        }
      })
    })
  }

  update(obj: any, columns: ColumnInfo[], predicates: relationalStore.RdbPredicates) {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns)
      this.rdbStore.update(value, predicates, (err, rows) => {
        if (err) {
          Logger.error('update failed', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('update success rows = ', rows.toString())
          resolve(rows)
        }
      })
    })
  }

  queryForList<T>(columns: ColumnInfo[], predicates: relationalStore.RdbPredicates): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(info => info.columnName), (err, resultSet) => {
        if (err) {
          Logger.error('select failed', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('select success rows = ', resultSet.rowCount.toString())
          resolve(this.parseResultSet(resultSet, columns))
        }
      })
    })
  }

  parseResultSet<T>(resultSet: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    let list = []
    if (resultSet.rowCount <= 0) {
      return list
    }
    for (let i = 0; i < resultSet.rowCount; i++) {
      resultSet.goToRow(i)
      let obj = {}
      columns.forEach((column) => {
        switch (column.type) {
          case ColumnType.LONG:
            obj[column.name] = resultSet.getLong(resultSet.getColumnIndex(column.columnName))
            break
          case ColumnType.DOUBLE:
            obj[column.name] = resultSet.getDouble(resultSet.getColumnIndex(column.columnName))
            break
          case ColumnType.STRING:
            obj[column.name] = resultSet.getString(resultSet.getColumnIndex(column.columnName))
            break
          case ColumnType.BLOB:
            obj[column.name] = resultSet.getBlob(resultSet.getColumnIndex(column.columnName))
            break
        }
      })
      list.push(obj)
    }
    return list
  }
}

let dbUtil: DbUtil = new DbUtil()

export default dbUtil as DbUtil