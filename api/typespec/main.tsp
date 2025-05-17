import "@typespec/http";
import "@typespec/json-schema";
using Http;
using TypeSpec.JsonSchema;

@service(#{ title: "Dapr Store API" })
@server("http://localhost:9000/v1.0/invoke", "Local dev server endpoint")
namespace NanoMon;

@tag("Orders")
@route("/orders/method")
interface OrdersOperations {
  /**
   * Get details of an order by ID
   */
  @route("/get/{id}")
  @get
  read(@path id: string): Order | Error;

  /**
   * Get all orders for a user
   */
  @route("/getForUser/{userId}")
  @get
  forUser(@path userId: string): string[] | Error;
}

@tag("Products")
@route("/products/method")
interface ProductsOperations {
  /**
   * Get all products in the catalog
   */
  @route("/catalog")
  @get
  catalog(): Product[] | Error;

  /**
   * Get all products on offer
   */
  @route("/offers")
  @get
  onOffer(): Product[] | Error;

  /**
   * Get a single product by ID
   */
  @route("/get/{id}")
  @get
  get(@path id: string): Product | Error;

  /**
   * Get all products matching a search term
   */
  @route("/search/{query}")
  @get
  search(@path query: string): Product[] | Error;
}

@tag("Cart")
@route("/cart/method")
interface CartOperations {
  /*
   * Get a cart for a user
   */
  @route("/get/{userId}")
  @get
  get(@path userId: string): Cart | Error;

  /*
   * Add or remove product to a user's cart
   * If quantity is 0, the product will be removed from the cart
   */
  @route("/setProduct/{userId}/{productId}/{quantity}")
  @put
  setProduct(
    @path userId: string,
    @path productId: string,
    @path quantity: int32,
  ): Cart | Error;

  /*
   * Submit a user's cart
   * This will create an order and clear the cart
   */
  @route("/submit")
  @post
  submit(@body userId: string): Order | Error;

  @doc("Empty a user's cart")
  @route("/clear/{userId}")
  @put
  clear(@path userId: string): Cart | Error;
}

@tag("Users")
@route("/users/method")
interface UsersOperations {
  /**
   * Register a new user
   */
  @route("/register")
  @post
  register(@body user: User): string | Error;

  /**
   * Check if a user is registered
   * This will return 204 if the user is registered, or 404 if not
   */
  @route("/isregistered/{userId}")
  @get
  isRegistered(@path userId: string): void | Error;

  /**
   * Get a user by ID
   */
  @route("/get/{userId}")
  @get
  get(@path userId: string): User | Error;
}

// ===== Models =========================

@jsonSchema
model Order {
  id: string;
  title: string;
  status: OrderStatus;
  forUser: string;
  amount: float32;
  lineItems: LineItem[];
}

@jsonSchema
model LineItem {
  count: int32;
  product: Product;
}

enum OrderStatus {
  New: "new",
  Received: "received",
  Processing: "processing",
  Complete: "complete",
}

@jsonSchema
model Product {
  id: string;
  name: string;
  cost: float32;
  description: string;
  image: string;
  onOffer: boolean;
}

@jsonSchema
model Cart {
  products: Record<int32>;
  forUserId: string;
}

@jsonSchema
model User {
  userId: string;
  email: string;
  displayName: string;
  profileImage?: string;
}

@error
model Error {
  status: int32;
  type: string;
  title: string;
  detail: string;
  instance: string;
}
