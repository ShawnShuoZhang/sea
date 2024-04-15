import window from '@ohos.window'
import common from '@ohos.app.ability.common'
import Header from '../view/Header'
import BoxList from '../view/BoxList'
import cloud, { Database } from '@hw-agconnect/cloud'
// @ts-ignore
import schema from '../../resources/rawfile/schema.json'
import { box } from '../model/box'

@Entry
@Component
struct Home {
  private uiContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  @State changeValue: string = ''
  @State submitValue: string = ''
  private database: Database = null

  async aboutToAppear() {
    let windowClass = await window.getLastWindow(this.uiContext)
    await windowClass.setWindowSystemBarEnable(['status', 'navigation'])
    this.database = cloud.database({
      zoneName: 'sea',
      objectTypeInfo: schema
    })
    for (let i = 0; i < 11; i++) {
      setInterval(() => this.getData(i), 1000 * 5)
    }
  }

  private getData(i: number) {
    let boxInfo = new box()
    // 获取当前时间戳
    let currentTimeStamp: number = Date.now();

    // 创建 Date 对象
    let date = new Date(currentTimeStamp);

    // 格式化日期字符串
    let formattedDate: string = `${date.getFullYear()}-${String(date.getMonth() + 1)
      .padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}-${String(date.getHours())
      .padStart(2, '0')}-${String(date.getMinutes()).padStart(2, '0')}-${String(date.getSeconds()).padStart(2, '0')}`;
    boxInfo.setTime('海洋牧场网箱' + (i + 1).toString() + ' ' + formattedDate)
    boxInfo.setTemperature(this.randomNum(40))
    boxInfo.setOxygen(this.randomNum(20))
    boxInfo.setPh(this.randomNum(14))
    boxInfo.setSalt(this.randomNum(0.1))
    boxInfo.setNitrite(this.randomNum(0.5))
    boxInfo.setAmmonia(this.randomNum(0.5))
    boxInfo.setName('海洋牧场网箱' + (i + 1).toString())
    boxInfo.setName_and_time(boxInfo.getName() + boxInfo.getTime())

    this.database.collection(box)
      .upsert(boxInfo)
      .then((res) => {
        console.info('upsert boxes success', JSON.stringify(res))
      })
      .catch((err) => {
        console.error('upsert boxes fail', JSON.stringify(err), Date.now().toString())
      })
  }

  //返回随机数，参数为随机数的范围
  randomNum(range: number): number {
    return Math.random() * range
  }

  build() {
    Column() {
      Header({
        headerName: '海洋牧场管理系统',
        changeValue: $changeValue,
        submitValue: $submitValue,
      })
      BoxList({
        changeValue: this.changeValue,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}