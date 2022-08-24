#[test_only]
module trpg::npc {
	use trpg::chara::{Self, Character};
	use trpg::item::{Self, Item};
	use sui::test_scenario::Self;
  use sui::vec_map;
  use sui::object;
  use std::debug;

	#[test]
	fun test_item_change() {
    let addr = @0x1;
    let scenario = test_scenario::begin(&addr);
    chara::new_chara(b"PC", 1, b"Main Character", b"{HP:10}", b"http://127.0.0.1/pc.png", test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, &addr);
    item::new_item(b"Health Potion", b"Restore HP", b"http://127.0.0.1/potion.png", test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, &addr);
    let pc = test_scenario::take_owned<Character>(&mut scenario);
    let potion = test_scenario::take_owned<Item>(&mut scenario);

    let items = chara::items(&pc);
    let i = object::id(&potion);
    debug::print(&i);
    assert!(!vec_map::contains(&items, &i), 1);
    
    chara::update_status(&mut pc, b"{HP:1}");
    debug::print(&pc);
    chara::add_item(&mut pc, &potion, 100);

    chara::burn_item(&mut pc, &potion, 1);
    debug::print(&pc);
    chara::update_status(&mut pc, b"{HP:10}");
    debug::print(&pc);
    chara::burn_item(&mut pc, &potion, 200);
    assert!(!vec_map::contains(&items, &i), 0);
    debug::print(&pc);

    chara::burn_item(&mut pc, &potion, 99);
    debug::print(&pc);
    assert!(!vec_map::contains(&items, &i), 1);
    test_scenario::return_owned(&mut scenario, pc);
    test_scenario::return_owned(&mut scenario, potion);
	}
}