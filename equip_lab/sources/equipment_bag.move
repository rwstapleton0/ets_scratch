/// module: equipment_bag
/// 
module equip_lab::equipment_bag {

    use sui::dynamic_object_field as ofield;

    public struct EquipmentBag<K: copy + drop + store> has key, store {
        id: UID,
        keys: vector<K>,
    }

    public fun new<K: copy + drop + store>(ctx: &mut TxContext): EquipmentBag<K> {
        EquipmentBag<K> {
            id: object::new(ctx),
            keys: vector::empty<K>(),
        }
    }

    public fun keys<K: copy + drop + store>(
        bag: &EquipmentBag<K>,
    ): vector<K> {
        bag.keys
    }

    public fun add<K: copy + drop + store, V: key + store>(
        bag: &mut EquipmentBag<K>,
        k: K,
        v: V,
    ) {
        // let key = k;
        vector::push_back(&mut bag.keys, k);
        ofield::add(&mut bag.id, k, v);
    }

    public fun remove<K: copy + drop + store, V: key + store>(
        bag: &mut EquipmentBag<K>,
        k: K,
    ): V {
        let (is_index, i) = vector::index_of(&bag.keys, &k);
        assert!(is_index, 0);
        vector::remove(&mut bag.keys, i);
        ofield::remove(&mut bag.id, k)
    }

    public fun borrow<K: copy + drop + store, V: key + store>(
        bag: &EquipmentBag<K>,
        k: K,
    ): &V {
        ofield::borrow(&bag.id, k)
    }

    public fun borrow_mut<K: copy + drop + store, V: key + store>(
        bag: &mut EquipmentBag<K>,
        k: K,
    ): &mut V {
        ofield::borrow_mut(&mut bag.id, k)
    }
    
    public fun contains_with_type<K: copy + drop + store, V: key + store>(
        bag: &EquipmentBag<K>,
        k: K,
    ): bool {
        ofield::exists_with_type<K, V>(&bag.id, k)
    }
}