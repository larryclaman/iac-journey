using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace scratch.Controllers
{
    [Route("api/[controller]")]
    public class DataController : Controller
    {
        [HttpGet("[action]")]
        public IEnumerable<Product> Products()
        {
            Product[] products = new Product[4]
            {
                new Product(1, "Outtop Foam Throwing Glider", "Foam throwing glider airplane", 10),
                new Product(2, "Fascinations Metal Earth 3D Laser Cut Model", "Wright Brothers airplane made of 3D laser cut metal", 20),
                new Product(3, "Vintage Model USMC Corsair Model Airplane", "Complete kit with realistic marking scheme", 30),
                new Product(4, "Delta Diecast Model Airplane", "Delta Single Plane Replica", 40)
            };

            return products;
        }

        public class Product
        {
            public int Id { get; set; }
            public string Title { get; private set; }
            public string Description { get; private set; }
            public int Quantity { get; private set; }

            public Product(int id, string title, string description, int quantity)
            {
                this.Id = id;
                this.Title = title;
                this.Description = description;
                this.Quantity = quantity;
            }
        }
    }
}
