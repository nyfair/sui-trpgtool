module trpg::chat {
  use std::ascii::{Self, String};
  use std::option::{Self, Option, some};
  use sui::object::{Self, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};

  struct Chat has key, store {
    id: UID,
    app_id: address,
    text: String,
    ref_id: Option<address>,
    metadata: vector<u8>,
  }

  public fun text(chat: &Chat): String {
    chat.text
  }

  fun post_internal(
    app_id: address,
    text: vector<u8>,
    ref_id: Option<address>,
    metadata: vector<u8>,
    ctx: &mut TxContext,
  ) {
    let chat = Chat {
      id: object::new(ctx),
      app_id,
      text: ascii::string(text),
      ref_id,
      metadata,
    };
    transfer::transfer(chat, tx_context::sender(ctx));
  }

  public entry fun post(
    app_identifier: address,
    text: vector<u8>,
    metadata: vector<u8>,
    ctx: &mut TxContext,
  ) {
    post_internal(app_identifier, text, option::none(), metadata, ctx);
  }

  public entry fun post_with_ref(
    app_identifier: address,
    text: vector<u8>,
    ref_identifier: address,
    metadata: vector<u8>,
    ctx: &mut TxContext,
  ) {
    post_internal(app_identifier, text, some(ref_identifier), metadata, ctx);
  }

  public entry fun burn(chat: Chat) {
    let Chat { id, app_id: _, text: _, ref_id: _, metadata: _ } = chat;
    object::delete(id);
  }
}