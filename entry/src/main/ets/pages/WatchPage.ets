import cloud, { Database } from '@hw-agconnect/cloud'
import router from '@ohos.router'
import Analyse from '../view/Analyse'
import BoxWatch from '../view/BoxWatch'
import { CardWaterQuality, QualityState } from '../viewModel/CardWaterQuality'
// @ts-ignore
import schema from '../../resources/rawfile/schema.json'
import { box } from '../model/box'

@Entry
@Component
struct WatchPage {
  private controller: TabsController = new TabsController()
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State boxName: string = 'Pond 1'
  @Watch('refresh') @State cardItem: CardWaterQuality = {
    name: 'Pond 1',
    state: QualityState.GOOD,
    oxygen: 10,
    oxyState: 'good',
    ph: 7,
    phState: 'good',
    temperature: 25,
    tempState: 'good',
    salt: 0,
    nitrite: 0,
    ammonia: 0,
    saltState: 'good',
    ammoniaState: 'good',
    nitriteState: 'good',
    nameAndTime: 'Pond 1  2021-07-01 12:00:00'
  }

  refresh() {
    this.cardItem.oxyState = this.cardItem.oxygen > 5 && this.cardItem.oxygen < 10 ? 'good' : 'bad'
    this.cardItem.phState = this.cardItem.ph > 7.5 && this.cardItem.ph < 8.5 ? 'good' : 'bad'
    this.cardItem.tempState = this.cardItem.temperature > 15 && this.cardItem.temperature < 25 ? 'good' : 'bad'
    this.cardItem.saltState = this.cardItem.salt > 0 && this.cardItem.salt < 0.1 ? 'good' : 'bad'
    this.cardItem.nitriteState = this.cardItem.nitrite > 0 && this.cardItem.nitrite < 0.2 ? 'good' : 'bad'
    this.cardItem.ammoniaState = this.cardItem.ammonia > 0 && this.cardItem.ammonia < 0.3 ? 'good' : 'bad'
    this.cardItem.state = this.cardItem.oxyState === 'good' && this.cardItem.phState === 'good' && this.cardItem.tempState === 'good' ? QualityState.GOOD : QualityState.BAD
  }

  @Builder
  TabBuilder(index: number, name: string, iconOn: ResourceStr, iconOff: ResourceStr) {
    Column() {
      Image(this.currentIndex === index ? iconOn : iconOff)
        .width(20)
        .margin({ top: 10 })
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 5, bottom: 7 })
    }.width('100%')
  }

  private database: Database = null
  private interval: number = 0

  async aboutToAppear() {
    await this.getData()
    this.interval = setInterval(async () => await this.getData(), 1000 * 5)
  }

  aboutToDisappear() {
    clearInterval(this.interval)
  }

  private async getData() {
    this.boxName = router.getParams()['boxName'] as string
    console.info('boxName:', this.boxName)
    this.database = cloud.database({
      zoneName: 'sea',
      objectTypeInfo: schema
    })
    let boxes: box[] = await this.database.collection(box)
      .query()
      .equalTo('name', this.boxName)
      .orderByDesc('time')
      .limit(1)
      .get()
    this.cardItem.name = boxes[0].name
    this.cardItem.oxygen = boxes[0].oxygen
    this.cardItem.temperature = boxes[0].temperature
    this.cardItem.ph = boxes[0].ph
    this.cardItem.salt = boxes[0].salt
    this.cardItem.nitrite = boxes[0].nitrite
    this.cardItem.ammonia = boxes[0].ammonia
    this.cardItem.nameAndTime = boxes[0].name_and_time
  }

  build() {
    Column() {
      Column({ space: 10 }) {
        Row() {
          Image($r('app.media.ic_public_back'))
            .width(20)
            .height(20)
            .onClick(() => {
              router.back()
            })
          Text(this.boxName)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
          Blank()
            .width(20)
        }
        .width('90%')
        .padding({ top: 40 })

        Divider()
      }
      .width('100%')
      .backgroundColor('#F1F3F5')

      Tabs({ controller: this.controller }) {
        TabContent() {
          BoxWatch({
            cardItem: this.cardItem
          })
        }.tabBar(this.TabBuilder(0, '实时数据', $r('app.media.ic_public_time_on'), $r('app.media.ic_public_time_off')))

        TabContent() {
          Analyse({
            name: this.boxName
          })
        }
        .tabBar(this.TabBuilder(1, '历史数据', $r('app.media.ic_public_analyse_on'), $r('app.media.ic_public_analyse_off')))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barPosition(BarPosition.End)
      .animationDuration(400)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ bottom: 30 })
  }
}