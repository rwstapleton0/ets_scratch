/// Module: equip_lab
module equip_lab::equip_lab {
    use sui::{dynamic_object_field as ofield, dynamic_field as field};
    use equip_lab::equipment_bag::{Self, EquipmentBag};

    public struct LabObj<phantom T: drop> has key, store {
        id: UID
    }

    public struct Scientist has drop {}

    public struct LabRabbit has drop {}

    public struct LabRat has drop {}

    public fun uid_mut<T: drop>(
        obj: &mut LabObj<T>,
    ): &mut UID {
        &mut obj.id
    }

    public fun new<T: drop>(ctx: &mut TxContext): LabObj<T> {
        LabObj {
            id: object::new(ctx)
        }
    }  

    public fun add_bag<T: drop>(
        obj: &mut LabObj<T>,
        ctx: &mut TxContext,
    ) {
        ofield::add(
            &mut obj.id,
            b"equipment_bag",
            equipment_bag::new<ID>(ctx),
        )
    }

    public fun add_number<T: drop>(
        obj: &mut LabObj<T>,
        number: u64
    ) {
        field::add(
            &mut obj.id,
            b"number",
            number
        )
    }

    public fun number<T: drop>(
        obj: &LabObj<T>
    ): u64 {
        *field::borrow<vector<u8>, u64>(
            &obj.id,
            b"number",
        )
    }

    public fun total_numbers<T: drop>( 
        obj: &LabObj<T>,
    ): u64 {
        let mut total = 0;

        let bag = 
            ofield::borrow<vector<u8>, EquipmentBag<ID>>(
                &obj.id,
                b"equipment_bag",
            );

        let keys = 
            equipment_bag::keys(bag);


        if (equipment_bag::contains_with_type<ID, LabObj<LabRabbit>>(bag, keys[1])) {
            let object = 
                equipment_bag::borrow<ID, LabObj<LabRabbit>>(bag, keys[1]);

            total = total + number(object);
        } else if (equipment_bag::contains_with_type<ID, LabObj<LabRat>>(bag, keys[1])) {
            let object = 
                equipment_bag::borrow<ID, LabObj<LabRat>>(bag, keys[1]);

            total = total + number(object);
        };
        total
    }

}
