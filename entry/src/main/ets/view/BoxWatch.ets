import { CardWaterQuality, QualityState } from '../viewModel/CardWaterQuality'

@Component
export default struct BoxWatch {
  @Prop cardItem: CardWaterQuality

  build() {
    Column({ space: 10 }) {
      List({ space: 10 }) {
        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.oxygen, type: ProgressType.Ring, total: 20 })
                .color(this.cardItem.oxyState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_o2'))
                .height(40)
            }

            Row() {
              Text(`${this.cardItem.oxygen.toFixed(3)}`)
                .margin({ left: 5 })
                .textAlign(TextAlign.Center)
              Text('mg/L')
                .fontSize(12)
            }
          }
          .cardStyle()
        }

        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.ph, type: ProgressType.Ring, total: 14 })
                .color(this.cardItem.phState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_ph'))
                .height(40)
            }

            Text(`${this.cardItem.ph.toFixed(3)}`)
              .textAlign(TextAlign.Center)
          }
          .cardStyle()
        }

        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.temperature, type: ProgressType.Ring, total: 40 })
                .color(this.cardItem.tempState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_temp'))
                .height(40)
            }

            Row() {
              Text(`${this.cardItem.temperature.toFixed(3)}`)
                .textAlign(TextAlign.Center)
              Text('°C')
                .fontSize(12)
            }
          }
          .cardStyle()
        }

        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.salt * 100, type: ProgressType.Ring, total: 10 })
                .color(this.cardItem.saltState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_public_salt'))
                .height(40)
            }

            Row() {
              Text(`${this.cardItem.salt.toFixed(3)}`)
                .textAlign(TextAlign.Center)
              Text('mg/L')
                .fontSize(12)
            }
          }
          .cardStyle()
        }

        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.ammonia * 20, type: ProgressType.Ring, total: 10 })
                .color(this.cardItem.ammoniaState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_public_ammonia'))
                .height(40)
            }

            Row() {
              Text(`${this.cardItem.ammonia.toFixed(3)}`)
                .textAlign(TextAlign.Center)
              Text('mg/L')
                .fontSize(12)
            }
          }
          .cardStyle()
        }

        ListItem() {
          Row() {
            Stack() {
              Progress({ value: this.cardItem.nitrite * 20, type: ProgressType.Ring, total: 10 })
                .color(this.cardItem.nitriteState === 'good' ? Color.Green : Color.Red)
                .height(80)
              Image($r('app.media.ic_public_nitrite'))
                .height(40)
            }

            Row() {
              Text(`${this.cardItem.nitrite.toFixed(3)}`)
                .textAlign(TextAlign.Center)
              Text('mg/L')
                .fontSize(12)
            }
          }
          .cardStyle()
        }
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical) // 排列方向
      .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果

    }
    .borderRadius(10)
    .padding(10)
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }
}

@Extend(Row)
function cardStyle() {
  .layoutWeight(1)
  .width('100%')
  .backgroundColor(Color.White)
  .padding(10)
  .borderRadius(10)
  .justifyContent(FlexAlign.SpaceEvenly)
}
