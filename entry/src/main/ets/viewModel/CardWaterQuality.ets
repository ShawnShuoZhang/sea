@Observed
export class CardWaterQuality {
  name: string;
  oxygen: number;
  ph: number;
  temperature: number;
  salt: number;
  //亚硝酸盐
  nitrite: number;
  //氨氮
  ammonia: number;
  state: QualityState;
  nameAndTime: string = '000';
  saltState: string = 'good'
  ammoniaState: string = 'good'
  nitriteState: string = 'good'
  oxyState: string = 'good'
  phState: string = 'good'
  tempState: string = 'good'

  constructor(oxygen: number = 0, ph: number = 7, temperature: number = 25, state: QualityState = QualityState.NORMAL,
              name: string = '1-1-1', salt: number = 0, nitrite: number = 0, ammonia: number = 0,nameAndTime: string = '000') {
    this.oxygen = oxygen;
    this.ph = ph;
    this.temperature = temperature;
    this.state = state;
    this.name = name;
    this.salt = salt;
    this.nitrite = nitrite;
    this.ammonia = ammonia;
    this.nameAndTime = nameAndTime;
  }
}

export enum QualityState {
  GOOD = 'good',
  BAD = 'bad',
  NORMAL = 'normal'
}