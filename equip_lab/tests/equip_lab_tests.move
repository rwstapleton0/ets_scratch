#[test_only]
module equip_lab::equip_lab_tests {
    use sui::{dynamic_object_field as ofield, test_scenario::{Self as ts, Scenario}};
    use equip_lab::equip_lab::{Self, LabObj, Scientist, LabRabbit, LabRat};
    use equip_lab::equipment_bag;

    const ADMIN: address = @0xAD;
    // const USER1: address = @0x1;

    #[test_only]
    public fun scientist(ts: &mut Scenario): LabObj<Scientist> {

        let mut scientist = 
            equip_lab::new<Scientist>(ts.ctx());
        equip_lab::add_bag(&mut scientist, ts.ctx());
        equip_lab::add_number( &mut scientist, 3 );

        let mut rabbit =
            equip_lab::new<LabRabbit>(ts.ctx());
        equip_lab::add_number( &mut rabbit, 3 );

        let mut rat =
            equip_lab::new<LabRat>(ts.ctx());
        equip_lab::add_number( &mut rat, 3 );

        equipment_bag::add(
            ofield::borrow_mut(
                equip_lab::uid_mut(&mut scientist),
                b"equipment_bag",
            ),
            object::id(&rabbit),
            rabbit
        );

        equipment_bag::add(
            ofield::borrow_mut(
                equip_lab::uid_mut(&mut scientist),
                b"equipment_bag",
            ),
            object::id(&rat),
            rat
        );

        scientist
    }

    #[test]
    public fun test_ets_app_init() {
        let mut ts = 
            ts::begin(ADMIN);

        let scientist =
            scientist(&mut ts);
        
        ts::next_tx(&mut ts, ADMIN);

        assert!(
            equip_lab::total_numbers(&scientist) == 3,
            0    
        );

        transfer::public_transfer(scientist, ADMIN);
        ts::end(ts);
    }
}
