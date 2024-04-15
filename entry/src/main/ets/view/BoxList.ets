import cloud, { Database } from '@hw-agconnect/cloud'
import router from '@ohos.router'
import { CardWaterQuality, QualityState } from '../viewModel/CardWaterQuality'
import BoxItem from './BoxItem'
// @ts-ignore
import schema from '../../resources/rawfile/schema.json'
import { box } from '../model/box'

@Component
export default struct BoxList {
  @State cardItems: CardWaterQuality[] = []
  @Prop changeValue: string
  private database: Database = null

  async aboutToAppear() {
    this.database = cloud.database({
      zoneName: 'sea',
      objectTypeInfo: schema
    })
    let boxes: box[] = await this.database.collection(box)
      .query()
      .orderByDesc('time')
      .greaterThan('time', (Date.now() - (5 * 60 * 1000)).toString())
      .get()
    let boxesMap = new Map<string, box>()
    boxes.forEach((value) => {
      if (!boxesMap.has(value.name)) {
        boxesMap.set(value.name, value)
      }
    })
    Array.from(boxesMap.values()).forEach((value) => {
      let cardItem = new CardWaterQuality()
      cardItem.name = value.name
      cardItem.oxygen = value.oxygen
      cardItem.ph = value.ph
      cardItem.temperature = value.temperature
      cardItem.salt = value.salt
      cardItem.nitrite = value.nitrite
      cardItem.ammonia = value.ammonia
      cardItem.nameAndTime = value.name_and_time
      this.cardItems.push(cardItem)
    })
  }

  build() {
    List({ space: 10, initialIndex: 0 }) {
      ForEach(this.cardItems.filter((value) => {
        if (this.changeValue) {
          console.debug('changeValue', this.changeValue)
          return value.name.includes(this.changeValue)
        } else {
          return value
        }
      }).sort((a, b) => {
        const num1 = parseInt(a.name.match(/\d+/)![0]);
        const num2 = parseInt(b.name.match(/\d+/)![0]);
        return num1 - num2;
      }), (item: CardWaterQuality) => {
        ListItem() {
          BoxItem({
            cardItem: item
          })
        }
        .onClick(() => {
          router.pushUrl({
            url: 'pages/WatchPage',
            params: {
              boxName: item.name,
            }
          })
        })
      }, (item:CardWaterQuality) => item.nameAndTime.toString())
    }
    .listDirection(Axis.Vertical) // 排列方向
    .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
    .onScrollIndex((firstIndex: number, lastIndex: number) => {
      console.info('first' + firstIndex)
      console.info('last' + lastIndex)
    })
    .width('90%')
    .layoutWeight(1)
  }
}
