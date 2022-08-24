#[test_only]
module trpg::npc {
	use trpg::chara::{Self, Character};
	use trpg::item::{Self, Item};
	use sui::test_scenario::Self;
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

    chara::update_status(&mut pc, b"{HP:1}");
    debug::print(&pc);
    chara::add_item(&mut pc, &potion, 100);
    debug::print(&pc);
    chara::burn_item(&mut pc, &potion, 1);
    debug::print(&pc);
    chara::update_status(&mut pc, b"{HP:10}");
    debug::print(&pc);
    test_scenario::return_owned(&mut scenario, pc);
    test_scenario::return_owned(&mut scenario, potion);
	}
}