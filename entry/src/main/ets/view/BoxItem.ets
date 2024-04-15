import { CardWaterQuality, QualityState } from '../viewModel/CardWaterQuality'
// @ts-ignore
import schema from '../../resources/rawfile/schema.json'
import { box } from '../model/box'
import cloud, { Database } from '@hw-agconnect/cloud'

@Component
@Preview
export default struct BoxItem {
  @Watch('refresh') @ObjectLink cardItem: CardWaterQuality
  private database: Database = null
  private interval: number

  async aboutToAppear() {
    await this.getData()
    this.refresh()
    this.interval = setInterval(async () => await this.getData(), 1000 * 10)
  }

  aboutToDisappear() {
    clearInterval(this.interval)
  }

  private async getData() {
    this.database = cloud.database({
      zoneName: 'sea',
      objectTypeInfo: schema
    })
    let boxes: box[] = await this.database.collection(box)
      .query()
      .equalTo('name', this.cardItem.name)
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

  refresh() {
    this.cardItem.oxyState = this.cardItem.oxygen > 5 && this.cardItem.oxygen < 10 ? 'good' : 'bad'
    this.cardItem.phState = this.cardItem.ph > 7.5 && this.cardItem.ph < 8.5 ? 'good' : 'bad'
    this.cardItem.tempState = this.cardItem.temperature > 15 && this.cardItem.temperature < 25 ? 'good' : 'bad'
    this.cardItem.state = this.cardItem.oxyState === 'good' && this.cardItem.phState === 'good' && this.cardItem.tempState === 'good' ? QualityState.GOOD : QualityState.BAD
    console.log('refresh')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text(this.cardItem.name)
          .textAlign(TextAlign.Start)
          .width('50%')

      }.width('100%')
      .padding({ left: 10, right: 10 })

      Divider()
      Row({ space: 10 }) {
        Column({ space: 10 }) {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.oxygen, type: ProgressType.Ring, total: 20 })
                .color(this.cardItem.oxyState === 'good' ? Color.Green : Color.Red)
                .height(40)
              Image($r('app.media.ic_o2'))
                .height(20)
            }

            Text(`${this.cardItem.oxygen.toFixed(1)}`)
              .width(40)
              .margin({ left: 5 })
              .textAlign(TextAlign.Center)
            Text('mg/L')
              .fontSize(12)
          }

          Text(this.cardItem.oxyState)
            .fontColor(this.cardItem.oxyState === 'good' ? Color.Green : Color.Red)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)

        Column({ space: 10 }) {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.ph, type: ProgressType.Ring, total: 14 })
                .color(this.cardItem.phState === 'good' ? Color.Green : Color.Red)
                .height(40)
              Image($r('app.media.ic_ph'))
                .height(20)
            }

            Text(`${this.cardItem.ph.toFixed(1)}`)
              .width(40)
              .textAlign(TextAlign.Center)
          }

          Text(this.cardItem.phState)
            .fontColor(this.cardItem.phState === 'good' ? Color.Green : Color.Red)
        }
        .layoutWeight(1).justifyContent(FlexAlign.Center)

        Column({ space: 10 }) {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.temperature, type: ProgressType.Ring, total: 40 })
                .color(this.cardItem.tempState === 'good' ? Color.Green : Color.Red)
                .height(40)
              Image($r('app.media.ic_temp'))
                .height(20)
            }

            Text(`${this.cardItem.temperature.toFixed(1)}`)
              .width(40)
              .margin({ left: 5 })
              .textAlign(TextAlign.Center)
            Text('°C')
              .fontSize(12)
          }

          Text(this.cardItem.tempState)
            .fontColor(this.cardItem.tempState === 'good' ? Color.Green : Color.Red)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      .margin({ top: 10 })
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')

    }
    .borderRadius(10)
    .padding(10)
    .backgroundColor(Color.White)
    .width('100%')
  }
}